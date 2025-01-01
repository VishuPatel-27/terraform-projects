# VPC Creation Using Terraform

This project demonstrates how to create a Virtual Private Cloud (VPC) using Terraform. The project includes all necessary Terraform configurations to set up a VPC with subnets, route tables, internet gateways, and more.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- [Terraform](https://www.terraform.io/downloads.html) (v0.12 or later)
- [AWS CLI](https://aws.amazon.com/cli/) configured with your AWS credentials
- An AWS account

## Project Structure

```
vpc-creation-using-terraform/
├── main.tf
├── variables.tf
├── terraform.tfvars
├── README.md
```

- `main.tf`: Contains the main Terraform configuration for the VPC.
- `variables.tf`: Defines the input variables for the Terraform configuration.
- `terraform.tfvars`: Specifies the variables value of the Terraform configuration.
- `README.md`: Project documentation.

## Usage

1. **Clone the repository:**

    ```sh
    git clone https://github.com/yourusername/vpc-creation-using-terraform.git
    cd vpc-creation-using-terraform
    ```

2. **Initialize Terraform:**

    ```sh
    terraform init
    ```

3. **Review the Terraform plan:**

    ```sh
    terraform plan
    ```

4. **Apply the Terraform configuration:**

    ```sh
    terraform apply
    ```

    Confirm the apply with `yes`.

5. **Destroy the Terraform-managed infrastructure (if needed):**

    ```sh
    terraform destroy
    ```

    Confirm the destroy with `yes`.

## Variables

The `variables.tf` file contains various input variables that you can customize:

- `region`: The AWS region where the VPC will be created.
- `vpc_cidr`: The CIDR block for the VPC.
- `public_subnet_cidrs`: A list of CIDR blocks for the public subnets.
- `private_subnet_cidrs`: A list of CIDR blocks for the private subnets.

You can override these variables by creating a `terraform.tfvars` file or by passing them directly in the command line:

```sh
terraform apply -var="region=us-west-2" -var="vpc_cidr=10.0.0.0/16"
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Contact

For any questions or support, please open an issue in the repository.
