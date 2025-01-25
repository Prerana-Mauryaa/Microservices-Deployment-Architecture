from flask import Flask, render_template, request, jsonify, flash, redirect, url_for
import grpc
import demo_pb2
import demo_pb2_grpc
import os

app = Flask(__name__, static_folder='static', static_url_path='/business/static')

@app.route('/business', methods=['POST', 'GET'])
def submit_form():
    if request.method == 'GET':
        return render_template('business.html')

    if request.method == 'POST':
        # Retrieve form data
        data = {
            'email': request.form.get('contact-number'),
            'product_name': request.form.get('product-name'),
            'categories': request.form.get('categories'),
            'price': request.form.get('price'),
        }

        # Initialize gRPC client and send the request
        try:
            value = os.getenv('EMAIL_SERVICE') 
            channel = grpc.insecure_channel(value)
            stub = demo_pb2_grpc.EmailServiceStub(channel)

            # Create the SendVerificationRequest message
            verification_request = demo_pb2.SendVerificationRequest(
                email=data['email'],
                product_name=data['product_name'],
                price=float(data['price']) if data['price'] else 0.0
            )

            # Call the SendVerificationEmail RPC
            response = stub.SendVerificationEmail(verification_request)

            # Handle the response
            if response.success:
                return render_template('business.html', success_message=f"{response.message}")
            else:
                return render_template('business.html', error_message=f"{response.message}")

        except grpc.RpcError as err:
            return render_template('business.html', error_message=f"Error: Unable to connect to the email service. Details: {err.details()}")

# Start the Flask app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5055, debug=True)
