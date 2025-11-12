from flask import Flask, request, jsonify
import joblib
import pandas as pd
import numpy as np

# Load model and scaler
model = joblib.load('rf_model.pkl')
scaler = joblib.load('scaler.pkl')

# Add your actual feature columns here (same as training)
feature_cols = [
    'duration', 'protocol_type', 'service', 'flag', 'src_bytes', 'dst_bytes', 'land',
    'wrong_fragment', 'urgent', 'hot', 'num_failed_logins', 'logged_in', 'num_compromised',
    'root_shell', 'su_attempted', 'num_root', 'num_file_creations', 'num_shells',
    'num_access_files', 'num_outbound_cmds', 'is_host_login', 'is_guest_login',
    'count', 'srv_count', 'serror_rate', 'srv_serror_rate', 'rerror_rate', 'srv_rerror_rate',
    'same_srv_rate', 'diff_srv_rate', 'srv_diff_host_rate', 'dst_host_count',
    'dst_host_srv_count', 'dst_host_same_srv_rate', 'dst_host_diff_srv_rate',
    'dst_host_same_src_port_rate', 'dst_host_srv_diff_host_rate', 'dst_host_serror_rate',
    'dst_host_srv_serror_rate', 'dst_host_rerror_rate', 'dst_host_srv_rerror_rate'
]

app = Flask(__name__)

@app.route('/')
def home():
    return "✅ NSL-KDD Random Forest API is running!"

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    if not data:
        return jsonify({'error': 'No input data received'}), 400

    # Create DataFrame
    df = pd.DataFrame([data], columns=feature_cols)

    # Scale and predict
    scaled = scaler.transform(df)
    pred = model.predict(scaled)[0]
    label = "normal" if pred == 1 else "attack"

    return jsonify({'prediction': int(pred), 'label': label})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
