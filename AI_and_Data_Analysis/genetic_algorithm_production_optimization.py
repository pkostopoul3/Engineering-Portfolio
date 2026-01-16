import numpy as np
from geneticalgorithm import geneticalgorithm as ga
import matplotlib.pyplot as plt

# 1.Define the fitness problem objective function
def fitness_function(X):
    X = X.astype(int) 
    total_units = np.sum(X)
    total_profit = 25 * X[0] + 41 * X[1] + 23 * X[2] + 54 * X[3]
    total_mech = 5 * X[0] + 9 * X[1] + 3 * X[2] + 7 * X[3]
    total_soft = 2 * X[0] + 2 * X[1] + 4 * X[2] + 7 * X[3]   
    if total_units > 1000 or total_mech > 7000 or total_soft > 4500:
        return -1  # Penalize infeasible solutions
    return -total_profit  # turn maximization into minimization

# Define variable boundaries 
varbound = np.array([[0, 1000], [0,1000], [0,1000], [0,1000]])

# 2.Define Genetic Algorithm parameters 
algorithm_params = {
    'max_num_iteration': 65,
    'population_size': 15,
    'mutation_probability': 0.02,
    'elit_ratio': 0.01,
    'parents_portion': 0.3,
    'crossover_probability': 0.8,
    'crossover_type': 'uniform', # One-point crossover
    'max_iteration_without_improv': None
}

best_fitnesses = []
best_solutions = []
all_reports = []

for i in range(10):
    # Create and run the model
    model = ga(function=fitness_function,
               dimension=4,
               variable_type='int',
               variable_boundaries=varbound,
               algorithm_parameters=algorithm_params)
    
    model.run()
    
    # Retrieve the results
    solution = model.output_dict['variable'].astype(int)
    fitness = -model.output_dict['function']
    
    best_fitnesses.append(fitness)
    best_solutions.append(solution)
    all_reports.append(model.report)
    print("Optimal Solution (Items Selected):", solution)
    print("Optimal Fitness (Total Value):", float(fitness))

# 3.Average profit
average_profit = np.mean(best_fitnesses)
print("\nThe average profit from 10 executions is:", float(average_profit))

# 4.Διάγραμμα Σύγκλισης (Βέλτιστο Τρέξιμο)
best_index = np.argmax(best_fitnesses)
best_report = all_reports[best_index]

plt.plot(best_report)
plt.title("Διάγραμμα Σύγκλισης (Βέλτιστο Τρέξιμο)")
plt.xlabel("Number of Clusters")
plt.ylabel("Negative Profit")
plt.grid(True)
plt.show()

# 6.Increase mutation probability to 30%
algorithm_params['mutation_probability'] = 0.3
mutation_fitnesses = []

for i in range(10):
    model = ga(function=fitness_function,
               dimension=4,
               variable_type='int',
               variable_boundaries=varbound,
               algorithm_parameters=algorithm_params)
    
    model.run()
    
    # Retrieve the results
    fitness = -model.output_dict['function']
    mutation_fitnesses.append(fitness)
    print("Optimal Fitness (Total Value):", float(fitness))

avg_mutation_profit = np.mean(mutation_fitnesses)
print("\nThe average profit with 30% mutation is:", float(avg_mutation_profit))

# 7.Parameter optimization
# We modify: population_size, elit_ratio και parents_portion
better_params = {
    'max_num_iteration': 65,
    'population_size': 30,
    'mutation_probability': 0.02,
    'elit_ratio': 0.1,
    'parents_portion': 0.4,
    'crossover_probability': 0.8,
    'crossover_type': 'uniform', # One-point crossover
    'max_iteration_without_improv': None
}

better_fitnesses = []
for i in range(10):
    # Create and run the model
    model = ga(function=fitness_function,
               dimension=4,
               variable_type='int',
               variable_boundaries=varbound,
               algorithm_parameters=algorithm_params)
    
    model.run()
    
    # Retrieve the results
    fitness = -model.output_dict['function']
    better_fitnesses.append(fitness)
    print("Optimal Fitness (Total Value):", float(fitness))

avg_better_profit = np.mean(better_fitnesses)
print("\nAverage Profit with Parameter Optimization:", float(avg_better_profit))
