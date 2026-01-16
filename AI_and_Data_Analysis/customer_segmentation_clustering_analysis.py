import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime
from scipy.cluster.hierarchy import dendrogram, linkage
from sklearn.cluster import AgglomerativeClustering
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score

# 1. Daraset, Total number of observations and First 5 rows
df = pd.read_csv("marketing_campaign.csv", sep='\t')

print("Ο συνολικός αριθμός παρατηρήσεων του dataset είναι:", len(df))

print("\nΟι πρώτες γραμμές του πίνακα είναι:")
print(df.head())

# 2. Delete observations that have missing values
df_clean = df.dropna()
print("Ο νέος αριθμός των διαθέσιμων γραμμών είναι:", len(df_clean))

# 3. New features in the dataset
df_new = df_clean.copy()

# Age calculation
df_new["Age"] = datetime.now().year - df_new["Year_Birth"]

# Total spending
df_new["Spent"] = 0
for col in ["MntWines", "MntFruits", "MntMeatProducts", "MntFishProducts", "MntSweetProducts", "MntGoldProds"]:
    df_new["Spent"] += df_new[col]
    
# Marital status
has_partner = []
for status in df_new["Marital_Status"]:
    if status in ["Married", "Together"]:
        has_partner.append(1)
    else:
        has_partner.append(0)

df_new["Has_Partner"] = has_partner

# Total children
df_new["Children"] = df_new["Kidhome"] + df_new["Teenhome"]

# Simplifying education level into 3 main groups
def map_education(level):
    if level in ["Basic", "2n Cycle"]:
        return 0  
    elif level in ["Graduation"]:
        return 1  
    elif level in ["Master", "PhD"]:
        return 2  
    else:
        return -1  

df_new["Education_Level"] = df_new["Education"].apply(map_education)

# Removing unnecessary columns
selected_columns = ["Income", "Recency", "Age", "Spent", "Has_Partner", "Children",
                    "Education_Level", "NumDealsPurchases", "NumWebPurchases",
                    "NumCatalogPurchases", "NumStorePurchases", "NumWebVisitsMonth"]

df_final = df_new[selected_columns]

print("\nΟι πρώτες γραμμές του νέου dataset είναι:")
print(df_final.head())

# 4. Ward dendrogram - Ιεραρχική Συσταδοποίηση
# Δημιουργία του linkage matrix με μέθοδο Ward
z = linkage(df_final, method='ward')

# Κατασκευή του δενδρογράμματος
plt.figure(figsize=(12, 6))
dendrogram(z)
plt.title("Δενδρόγραμμα με Ward Linkage")
plt.xlabel("Δείγματα")
plt.ylabel("Απόσταση Συγχώνευσης")
plt.grid(True)
plt.show()

# 5. Υπολογισμός καλύτερης απόδοσης
# Εφαρμογή agglomerative clustering με Ward linkage
model = AgglomerativeClustering(n_clusters=4, linkage='ward')
labels_agg = model.fit_predict(df_final)

# Οπτικοποίηση αποτελεσμάτων (Age/Spent)
plt.figure(figsize=(12, 6))
plt.scatter(df_final["Age"], df_final["Spent"], c=labels_agg, cmap='viridis', edgecolor='k', s=50)
plt.title('Agglomerative Clustering με Ward linkage')
plt.xlabel('Age')
plt.ylabel('Spent')
plt.grid(True)
plt.show()

# K-Means clustering
kmeans = KMeans(n_clusters=4, random_state=0)
labels_kmeans = kmeans.fit_predict(df_final)
centers = kmeans.cluster_centers_

#Silhouette scores
silhouette_agg = silhouette_score(df_final, labels_agg)
print(f"\nAgglomerative Clustering Silhouette Score: {silhouette_agg:.4f}")
silhouette_kmeans = silhouette_score(df_final, labels_kmeans)
print(f"\nΜέσο Silhouette Score: {silhouette_kmeans:.4f}")

if silhouette_kmeans > silhouette_agg:
    print("\nΤο K-Means clustering έκανε καλύτερη συνοχή μεταξύ των ομάδων.")
elif silhouette_kmeans < silhouette_agg:
    print("\nΗ Ιεραρχική συσταδοποίηση με Ward έκανε καλύτερη ομαδοποίηση.")
else:
    print("\nΚαι οι δύο μέθοδοι εμφάνισαν ίδια απόδοση.")
    
# 6. Ανάλυση Silhouette για εύρος τιμών k (2-15)
range_n_clusters = list(range(2, 16))
silhouette_avg_scores = []
for n_clusters in range_n_clusters:
    kmeans = KMeans(n_clusters=n_clusters, random_state=0)
    cluster_labels = kmeans.fit_predict(df_final)
    silhouette_avg = silhouette_score(df_final, cluster_labels)
    silhouette_avg_scores.append(silhouette_avg)
    print(f"\nFor n_clusters = {n_clusters}, the average silhouette_score is : {silhouette_avg:.4f}")
    
# Οπτικοποίηση αποτελεσμάτων
plt.figure(figsize=(12, 6))
plt.plot(range_n_clusters, silhouette_avg_scores, marker='o')
plt.title("Silhouette Scores για διαφορετικό αριθμό συστάδων")
plt.xlabel("Αριθμός συστάδων")
plt.ylabel("Μέσο Silhouette Score")
plt.xticks(range_n_clusters)
plt.grid(True)
plt.show()

# 7. Excel file for better clustering
# Μετατροπή των labels σε DataFrame
labels_df = pd.DataFrame(labels_kmeans)
labels_df.to_excel("kmeans_labels_only.xlsx", index=False, engine="openpyxl")
print("Το αρχείο 'kmeans_labels_only.xlsx' δημιουργήθηκε επιτυχώς!")





