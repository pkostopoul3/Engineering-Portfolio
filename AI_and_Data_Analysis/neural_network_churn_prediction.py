import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import GridSearchCV
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix, ConfusionMatrixDisplay, accuracy_score

# 1. Daraset, Total number of observations and First 5 rows
df = pd.read_excel("Telco_customer_churn.xlsx")

print("Ο συνολικός αριθμός παρατηρήσεων του dataset είναι:", len(df))

print("\nΟι πρώτες γραμμές του πίνακα είναι:")
print(df.head())

# 2. Delete observations that have missing values
df_clean = df.dropna()
print("\nΟ νέος αριθμός των διαθέσιμων γραμμών είναι:", len(df_clean))

# 3. Πρόβλεψη Churn Value, αφαίρεση μη χρήσιμων μεταβλητών και Barplot
# a. Διαχωρισμός
df = df_clean.drop(columns=["CustomerID", "Churn Label", "Churn Reason", "Churn Score",'Country', 
                            'State', 'City', 'Lat Long','Latitude', 'Longitude', 'Senior Citizen',
                            'Internet Service', 'Contract', 'Payment Method', ], errors='ignore')
# b. Έλεγχος διαστάσεων
print(df_clean['Churn Value'].value_counts())    
print(df_clean['Churn Value'].unique())

df_clean = df[df['Total Charges'] != ' ']
df_clean['Total Charges'] = df_clean['Total Charges'].astype(float)
    
# Barplot για τη μεταβλητή στόχο "Churn Value"
plt.figure(figsize=(6, 4))
sns.countplot(x="Churn Value", data=df_clean, legend=False)
plt.title("Κατανομή της μεταβλητής στόχου 'Churn Value'")
plt.xlabel("Κατανομή")
plt.ylabel("Πλήθος")
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.tight_layout()
plt.show()
 
# 4. Train/test-split και χρήση νευρωνικών δικτύων
# Μετατροπή μεταβλητών σε αριθμητική μορφή
df_clean['Gender'] = df_clean['Gender'].map({'Female': 0, 'Male': 1})
df_clean['Partner'] = df_clean['Partner'].map({'No': 0, 'Yes': 1})
df_clean['Dependents'] = df_clean['Dependents'].map({'No': 0, 'Yes': 1})
df_clean['Phone Service'] = df_clean['Phone Service'].map({'No': 0, 'Yes': 1})
# 'No phone service' και 'No internet service'
df_clean['Multiple Lines'] = df_clean['Multiple Lines'].map({'No phone service': 0, 'No': 0, 'Yes': 1})
df_clean['Online Security'] = df_clean['Online Security'].map({'No internet service': 0, 'No': 0, 'Yes': 1})
df_clean['Online Backup'] = df_clean['Online Backup'].map({'No internet service': 0, 'No': 0, 'Yes': 1})
df_clean['Device Protection'] = df_clean['Device Protection'].map({'No internet service': 0, 'No': 0, 'Yes': 1})
df_clean['Tech Support'] = df_clean['Tech Support'].map({'No internet service': 0, 'No': 0, 'Yes': 1})
df_clean['Streaming TV'] = df_clean['Streaming TV'].map({'No internet service': 0, 'No': 0, 'Yes': 1})
df_clean['Streaming Movies'] = df_clean['Streaming Movies'].map({'No internet service': 0, 'No': 0, 'Yes': 1})
df_clean['Paperless Billing'] = df_clean['Paperless Billing'].map({'No': 0, 'Yes': 1})

X = df_clean.drop(columns=['Churn Value'])
y = df_clean['Churn Value']

# Split 80/20
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)
# Εκπαίδευση μοντέλου
model = MLPClassifier(hidden_layer_sizes=(11,12,11,11,8), activation='relu',
                      solver='adam', max_iter=2000, random_state=1)
model.fit(X_train, y_train)
# Αξιολόγηση
#y_pred = model.predict(X_test)

# Ορισμός πλέγματος παραμέτρων
param_grid = {
    'hidden_layer_sizes': [(10,), (30,), (30, 10)],
    'activation': ['relu', 'tanh'],
    'solver': ['adam', 'sgd'],
    'learning_rate_init': [0.001, 0.0005, 0.0001],
    'alpha': [0.0001, 0.001, 0.01]}
# Ορισμός GridSearchCV
model = MLPClassifier(max_iter=2000, random_state=42)
grid_search = GridSearchCV(
    estimator=model,
    param_grid=param_grid,
    cv=10,
    scoring='accuracy',
    n_jobs=-1)
# Εκπαίδευση
grid_search.fit(X_train, y_train)
# Αποτελέσματα
print("Καλύτερες παράμετροι:", grid_search.best_params_)
print("Καλύτερη ακρίβεια CV:", grid_search.best_score_)

# 5. Confusion Matrix και Classification Report
# a. Καλύτερο μοντέλο στις προβλέψεις
y_pred_best = grid_search.best_estimator_.predict(X_test) 
# b. Ακρίβεια
print("Ακρίβεια στο test set:", accuracy_score(y_test, y_pred_best))
# c. Confusion Matrix
cm = confusion_matrix(y_test, y_pred_best, labels=[0,1])
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=[0,1])
plt.figure(figsize=(6, 4))
disp.plot(cmap='Blues', values_format='d')
plt.title("Confusion Matrix")
plt.grid(False)
plt.show()
# d. Classification Report
print("\nΑναφορά Απόδοσης:")
print(classification_report(y_test, y_pred_best, labels=[0,1], zero_division=0))