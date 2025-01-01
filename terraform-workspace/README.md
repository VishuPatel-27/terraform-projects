# Terraform Workspace Project

This project demonstrates the use of Terraform workspaces to manage multiple environments (dev, stage, and prod) with different configurations. The project includes a module called `ec2-creation` that creates an EC2 instance and installs Nginx on it.

## Project Structure

```
terraform-workspace/
├── modules/
│   └── ec2-creation/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── env/
│   ├── dev.tfvars
│   ├── stage.tfvars
│   └── prod.tfvars
├── main.tf
├── variables.tf
└── README.md
```

## Environments

The project uses three workspaces:
- `dev`
- `stage`
- `prod`

Each workspace has its own set of variable values defined in the respective `.tfvars` files located in the `env` folder (`env/dev.tfvars`, `env/stage.tfvars`, `env/prod.tfvars`).

## Module: ec2-creation

The `ec2-creation` module is responsible for creating an EC2 instance and installing Nginx on it. The module is reusable and can be configured with different parameters for each environment.

### Module Files

- `main.tf`: Contains the resource definitions for the EC2 instance and the Nginx installation.
- `variables.tf`: Defines the input variables for the module.
- `outputs.tf`: Defines the output values for the module.

## Usage

1. Initialize the Terraform project:
    ```sh
    terraform init
    ```

2. Select the desired workspace:
    ```sh
    terraform workspace select dev
    # or
    terraform workspace select stage
    # or
    terraform workspace select prod
    ```

3. Apply the configuration for the selected workspace:
    ```sh
    terraform apply -var-file=env/dev.tfvars
    # or
    terraform apply -var-file=env/stage.tfvars
    # or
    terraform apply -var-file=env/prod.tfvars
    ```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Author

This project is maintained by Vishukumar Patel.
