import numpy as np
import matplotlib.pyplot as plt
import random
import math

class COMVRP:
   # Combined Vehicle Routing Problem solver using private and hired vehicles
   
   def __init__(self, filename):
       # Initialize solver with problem instance from file
       self.read_data(filename)
       self.dist_matrix = self.calculate_distances() 
       self.Nu = 5  # Number of private vehicles available

   def read_data(self, filename):
       # Read problem data from file
       with open(filename, 'r') as f:
           self.N = int(f.readline())  # Number of customers
           self.Q = int(f.readline())  # Vehicle capacity
           self.H = int(f.readline())  # Maximum route duration
           self.s = int(f.readline())  # Service time per customer
           
           # Read customer coordinates
           self.coords = []
           for i in range(self.N):
               line = f.readline().split()
               self.coords.append([float(line[1]), float(line[2])])
           self.coords = np.array(self.coords)
           
           # Read customer demands
           self.demands = []
           for i in range(self.N):
               line = f.readline().split()
               self.demands.append(int(line[1]))
           self.demands = np.array(self.demands)

   def calculate_distances(self):
       # Calculate distance matrix between all locations
       dist = np.zeros((self.N, self.N))
       for i in range(self.N):
           for j in range(self.N):
               dist[i,j] = math.sqrt(sum((self.coords[i] - self.coords[j])**2))
       return dist

   def clarke_wright_savings(self):
       # Generate initial solution using Clarke-Wright savings algorithm
       private_routes = []

       # Create private vehicle routes
       unserved = set(range(1, self.N))
       for _ in range(self.Nu):
           if not unserved:
               break
           route = [0]
           while True:
               best_saving = float('-inf')
               best_next = None
               for i in unserved:
                   new_route = route + [i, 0]
                   if self.is_feasible_route(new_route, True):
                       saving = self.dist_matrix[0,route[-1]] + self.dist_matrix[0,i] - self.dist_matrix[route[-1],i]
                       if saving > best_saving:
                           best_saving = saving
                           best_next = i
               if best_next is None:
                   break
               route.append(best_next)
               unserved.remove(best_next)
           if len(route) > 1:
               route.append(0)
               private_routes.append(route)

       # Create hired vehicle routes for remaining customers
       hired_routes = []
       while unserved:
           route = [0]
           while True:
               best_saving = float('-inf') 
               best_next = None
               for i in unserved:
                   new_route = route + [i]
                   if self.is_feasible_route(new_route, False):
                       saving = self.dist_matrix[0,route[-1]] + self.dist_matrix[0,i] - self.dist_matrix[route[-1],i]
                       if saving > best_saving:
                           best_saving = saving
                           best_next = i
               if best_next is None:
                   break
               route.append(best_next)
               unserved.remove(best_next)
           if len(route) > 1:
               hired_routes.append(route)

       routes = private_routes + hired_routes
       is_private = [True] * len(private_routes) + [False] * len(hired_routes)
       return routes, is_private

   def two_opt(self, route, is_private):
       # Improve route using 2-opt local search
       best_route = route
       best_time = self.route_time(route, is_private)
       improved = True
       
       while improved:
           improved = False

           i_limit = len(route) - 2 if is_private else len(route) - 1
           j_limit = len(route) - 1 if is_private else len(route)

           for i in range(1, i_limit):
               for j in range(i+1, j_limit):
                   new_route = route[:i] + route[i:j+1][::-1] + route[j+1:]
                   if self.is_feasible_route(new_route, is_private):
                       new_time = self.route_time(new_route, is_private)
                       if new_time < best_time:
                           best_route = new_route
                           best_time = new_time
                           improved = True
                           break
               if improved:
                   break
       return best_route

   def one_one_exchange(self, route1, route2, is_private1, is_private2):
       # Exchange customers between two routes to improve solution
       best_r1, best_r2 = route1, route2
       best_time = self.route_time(route1, is_private1) + self.route_time(route2, is_private2)

       i_limit = len(route1) - 1 if is_private1 else len(route1)
       j_limit = len(route2) - 1 if is_private2 else len(route2)
       for i in range(1, i_limit):
           for j in range(1, j_limit):
               new_r1 = route1[:i] + [route2[j]] + route1[i+1:]
               new_r2 = route2[:j] + [route1[i]] + route2[j+1:]
               
               if (self.is_feasible_route(new_r1, is_private1) and self.is_feasible_route(new_r2, is_private2)):
                   new_time = self.route_time(new_r1, is_private1) + self.route_time(new_r2, is_private2)
                   if new_time < best_time:
                       best_r1, best_r2 = new_r1, new_r2
                       best_time = new_time
       return best_r1, best_r2

   def grasp(self, routes, is_private):
       # Improve solution using GRASP metaheuristic
       best_routes = routes
       best_is_private = is_private
       best_time = sum(self.route_time(r,p) for r,p in zip(routes,is_private))
       
       for _ in range(5000):  # Number of GRASP iterations
           unserved = list(range(1, self.N))
           current_routes = []
           current_is_private = []
           
           # Build private routes
           for _ in range(self.Nu):
               if not unserved:
                   break
               route = [0]
               while unserved:
                   rcl = []  # Restricted candidate list
                   for i in unserved:
                       new_route = route + [i, 0]
                       if self.is_feasible_route(new_route, True):
                           dist = self.dist_matrix[route[-1]][i]
                           rcl.append((dist,i))
                   
                   if not rcl:
                       break
                   
                   # Select random customer from best candidates
                   rcl.sort()
                   max_idx = min(3, len(rcl))
                   idx = random.randint(0, max_idx-1)
                   _, next_cust = rcl[idx]
                   
                   route.append(next_cust)
                   unserved.remove(next_cust)
               
               if len(route) > 1:
                   route.append(0)
                   current_routes.append(route)
                   current_is_private.append(True)
           
           # Build hired routes for remaining customers
           while unserved:
               route = [0]
               while unserved:
                   rcl = []
                   for i in unserved:
                       new_route = route + [i]
                       if self.is_feasible_route(new_route, False):
                           dist = self.dist_matrix[route[-1]][i] #Distance between last customer [-1] and i customer
                           rcl.append((dist,i))
                   
                   if not rcl:
                       break
                   
                   rcl.sort()
                   max_idx = min(3, len(rcl))
                   idx = random.randint(0, max_idx-1)
                   _, next_cust = rcl[idx]
                   
                   route.append(next_cust)
                   unserved.remove(next_cust)
               
               if len(route) > 1:
                   current_routes.append(route)
                   current_is_private.append(False)
           
           if unserved:
               continue
               
           current_time = sum(self.route_time(r,p) for r,p in zip(current_routes,current_is_private))
           
           if current_time < best_time:
               best_routes = current_routes
               best_is_private = current_is_private
               best_time = current_time
               
       return best_routes, best_is_private

   def route_time(self, route, is_private=True):
       # Calculate total time for a route including travel and service time
       total_dist = 0
       service_time = 0
       for i in range(len(route) - 1):
           total_dist += self.dist_matrix[route[i]][route[i + 1]]
           if route[i] != 0:  # Add service time only for customers, not depot
               service_time += self.s
       # if is_private:
       #     total_dist += self.dist_matrix[route[-1]][0]  # Return to depot
       return total_dist + service_time

   def is_feasible_route(self, route, is_private=True):
       # Check if route satisfies capacity and duration constraints
       if sum(self.demands[i] for i in route[1:]) > self.Q:
           return False
       time = self.route_time(route, is_private)
       return time <= self.H #If time is larger than self.H then it returns false.

   def plot_solution(self, routes, is_private):
       # Visualize solution with routes for private and hired vehicles
       plt.figure(figsize=(12,8))
       plt.scatter(self.coords[0,0], self.coords[0,1], c='r', s=200, marker='s', label='Depot')
       plt.scatter(self.coords[1:,0], self.coords[1:,1], c='b', s=100, label='Customers')
       
       colors = ['g','m','y','k','c']
       
       for i, (route, is_priv) in enumerate(zip(routes, is_private)):
           color = colors[i % len(colors)]
           label = f'Private {i+1}' if is_priv else f'Hired {i+1}'
           
           for j in range(len(route)-1):
               p1 = self.coords[route[j]]
               p2 = self.coords[route[j+1]]
               plt.plot([p1[0],p2[0]], [p1[1],p2[1]], c=color, label=label if j==0 else "")
       
       plt.title("COMVRP Solution")
       plt.legend()
       plt.grid(True)
       plt.show()

   def solve(self):
       # Main solving procedure combining construction and improvement
       # Get initial solution
       routes, is_private = self.clarke_wright_savings()
       routes, is_private = self.grasp(routes, is_private)
       # Improve solution with local search
       improved = True
       while improved:
           improved = False
           for i in range(len(routes)):
               new_route = self.two_opt(routes[i], is_private[i])
               if new_route != routes[i]:
                   routes[i] = new_route #Saving all new routes that the two opt made
                   improved = True
           
           for i in range(len(routes)):
               for j in range(i+1, len(routes)):
                       new_r1, new_r2 = self.one_one_exchange(routes[i], routes[j], is_private[i], is_private[j])
                       if new_r1 != routes[i]:
                           routes[i] = new_r1
                           routes[j] = new_r2
                           improved = True


       # Calculate solution metrics
       total_distance = sum(sum(self.dist_matrix[r[i]][r[i+1]] for i in range(len(r)-1)) for r in routes)
       total_time = sum(self.route_time(r,p) for r,p in zip(routes,is_private))
       
       # Print solution summary
       print("\nSummary:")
       print("-"*50)
       print(f"Total routes: {len(routes)}")
       print(f"Private vehicles: {sum(is_private)}")
       print(f"Hired vehicles: {len(routes)-sum(is_private)}")
       print(f"Total distance: {total_distance:.2f}")
       print(f"Total time: {total_time:.2f}")
       
       print("\nDetailed Route Information:")
       print("-"*50)
       for i,(r,p) in enumerate(zip(routes,is_private)):
           print(f"\nRoute {i+1} ({'Private' if p else 'Hired'}):")
           print(f"Nodes: {r}")
           print(f"Load: {sum(self.demands[j] for j in r[1:-1] if j < len(self.demands))}")
           print(f"Time: {self.route_time(r,p):.2f}")
       
       self.plot_solution(routes, is_private)
       return routes, is_private

if __name__ == "__main__":
   problem = COMVRP("Provlima1.txt")
   routes, is_private = problem.solve()