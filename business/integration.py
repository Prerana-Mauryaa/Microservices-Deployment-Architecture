import grpc
from . import product_service_pb2
from . import product_service_pb2_grpc

# Define the gRPC client
def add_product_to_catalog(product):
    # Connect to gRPC service
    channel = grpc.insecure_channel('localhost:50051')  # Adjust the server address if necessary
    stub = product_service_pb2_grpc.ProductServiceStub(channel)

    # Construct gRPC request
    request = product_service_pb2.ProductRequest(
        id=product['id'],
        name=product['name'],
        description=product['description'],
        categories=','.join(product['categories']),
        currency_code=product['priceUsd']['currencyCode'],
        price_units=product['priceUsd']['units'],
        price_nanos=product['priceUsd']['nanos'],
        picture=product['picture']
    )
    
    # Call the gRPC service
    response = stub.AddProduct(request)
    return response
