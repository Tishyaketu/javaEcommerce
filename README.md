# Micro Marketplace: Java E-commerce Microservices

Micro Marketplace is a robust e-commerce application built on a microservices architecture using Spring Boot, Spring Cloud, and modern distributed system patterns. This project demonstrates best practices in service development, security, observability, and asynchronous communication.

## 🚀 Features

- **Microservices Architecture:** Independently deployable services for Product, Order, Inventory, and Notification.
- **Service Discovery:** Netflix Eureka for dynamic service registration and lookup.
- **API Gateway:** Spring Cloud Gateway as a single entry point for routing and cross-cutting concerns.
- **Security:** Integrated with Keycloak for robust Authentication and Authorization (OAuth2/OIDC).
- **Communication:**
  - **Synchronous:** WebClient for inter-service calls.
  - **Asynchronous:** Apache Kafka for event-driven notifications.
- **Resilience:** Resilience4j for circuit breaking and fault tolerance.
- **Observability:**
  - **Distributed Tracing:** Micrometer and Zipkin.
  - **Metrics & Monitoring:** Prometheus and Grafana.

## 🛠️ Technology Stack

| Category | Technologies |
| :--- | :--- |
| **Backend** | Java 17, Spring Boot 3.1.2, Spring Cloud 2022.0.4 |
| **Databases** | MongoDB (Product), MySQL (Order, Inventory) |
| **Messaging** | Apache Kafka |
| **Security** | Keycloak |
| **Observability** | Prometheus, Grafana, Zipkin, Micrometer |
| **Containerization** | Docker, Docker Compose |
| **Build Tool** | Maven |

## 📂 Project Structure

- `api-gateway`: Entry point for all requests.
- `discovery-server`: Eureka server for service discovery.
- `product-service`: Manages product catalog (MongoDB).
- `order-service`: Manages customer orders (MySQL).
- `inventory-service`: Tracks product stock (MySQL).
- `notification-service`: Consumes Kafka events to send notifications.
- `prometheus`: Monitoring configuration.

## 🏁 Getting Started

### Prerequisites

- Docker and Docker Compose installed and running.
- Java 17 (if running services locally without Docker).
- Maven (if building from source).

### Deployment

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd javaEcommerce
    ```

2.  **Start all services and infrastructure:**
    ```bash
    docker-compose up -d
    ```

3.  **Verify the setup:**
    ```bash
    docker ps
    ```
    Ensure all containers (MySQL, MongoDB, Kafka, Keycloak, and Spring services) are healthy.

### 🔐 Security Setup (Keycloak)

To automate the configuration of Keycloak (Realm, Client, and Secrets), run the provided setup script:

```bash
chmod +x setup-keycloak.sh
./setup-keycloak.sh
```

This script will:
- Create the `spring-boot-microservices-realm`.
- Create the `spring-cloud-client`.
- Generate a client secret and save it to `client_secret.txt`.

## 📖 Usage & API Documentation

### 1. Authenticate (Get Token)
Use Postman or curl to get an OAuth2 token from Keycloak.
- **Grant Type:** Client Credentials
- **Access Token URL:** `http://localhost:8080/realms/spring-boot-microservices-realm/protocol/openid-connect/token`
- **Client ID:** `spring-cloud-client`
- **Client Secret:** (Check `client_secret.txt`)

### 2. Product API
- **Create Product:** `POST http://localhost:8181/api/product`
- **Get All Products:** `GET http://localhost:8181/api/product`

### 3. Order API
- **Place Order:** `POST http://localhost:8181/api/order`
  ```json
  {
    "orderLineItemsDtoList": [
      {
        "skuCode": "iphone_17",
        "price": 1200,
        "quantity": 1
      }
    ]
  }
  ```

## 📊 Observability Dashboards

| Tool | URL | Description |
| :--- | :--- | :--- |
| **Eureka** | [http://localhost:8761](http://localhost:8761) | Service registration status |
| **Keycloak** | [http://localhost:8080](http://localhost:8080) | Identity and Access Management |
| **Zipkin** | [http://localhost:9411](http://localhost:9411) | Distributed tracing |
| **Prometheus** | [http://localhost:9090](http://localhost:9090) | High-level metrics |
| **Grafana** | [http://localhost:3000](http://localhost:3000) | Visualization and dashboards |

## 🧹 Cleanup

To stop and remove all resources:
```bash
docker-compose down -v
```

---
*Developed as a Microservices learning project.*
