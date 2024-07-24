# Terraform - Benchmark OVH MongoDB Instance with YCSB

The intent of this project is to run the YCSB (Yahoo! Cloud Serving Benchmark) tool on an OVH MongoDB managed instance. The script will instantiate the MongoDB OVH instance and a VM to execute the YCSB script.

## Getting Started

### Prerequisites

- Terraform installed on your machine
- Access to an OVH account
- Properly configured OVH credentials

### Setup

1. **Clone the repository:**

    ```sh
    git clone https://github.com/ralphsawaya/ovh.git
    cd ovh/Terraform
    ```

2. **Provide Variables:**

    Create a `terraform.tfvars` file and provide the necessary variables. Here is an example:

    ```hcl
    # terraform.tfvars
    variable_name = "value"
    another_variable = "another_value"
    ```

3. **Provide Custom Workload Content:**

    Before running Terraform, make sure to customize `myworkload` content according to your requirements.

### Usage

1. **Initialize Terraform:**

    ```sh
    terraform init
    ```

2. **Apply Terraform Configuration:**

    ```sh
    terraform apply
    ```

3. **Destroy Infrastructure:**

    Once you are done, you can destroy the infrastructure to avoid unnecessary costs:

    ```sh
    terraform destroy
    ```

### Logs and Results

- Logs for the instantiated VM can be found at:
  - `/var/log/ycsb_init.log`
  - `/var/log/ycsb_result.log`

- These log files will be automatically pushed to OVH S3 at the end of the execution.

## Contributing

Feel free to submit issues and enhancement requests.

## License

Distributed under the MIT License. See `LICENSE` for more information.
