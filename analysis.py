import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, accuracy_score

def run_analysis():
    print("--- Starting Patient Outcomes Data Analytics Pipeline ---\n")
    
    # Check if dataset exists
    data_path = 'data/heart.csv'
    if not os.path.exists(data_path):
        data_path = '../data/heart.csv' # Check parent folder relative path too
        
    if not os.path.exists(data_path):
        print("Error: heart.csv dataset file could not be found.")
        return
        
    df = pd.read_csv(data_path)
    print(f"Dataset successfully loaded. Total records: {len(df)}")
    
    # Summary Metrics
    print("\n[1] Patient Demographics & Key Clinical Biometrics Summary:")
    print(df[['age', 'trestbps', 'chol', 'thalach']].describe().to_string())
    
    # Feature Means relative to heart disease status
    print("\n[2] Comparison of Clinical Averages by Outcome State:")
    print(df.groupby('target')[['age', 'trestbps', 'chol', 'thalach']].mean().to_string())
    
    # Predictive Analytics Baseline
    X = df.drop(columns=['target'])
    y = df['target']
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)
    
    model = LogisticRegression(max_iter=1000)
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)
    
    print("\n[3] Model Evaluation (Logistic Regression Baseline Classifier):")
    print(f"Accuracy Metric: {accuracy_score(y_test, y_pred):.4%}")
    print("\nDetailed Classification Matrix:")
    print(classification_report(y_test, y_pred))

if __name__ == '__main__':
    run_analysis()
