# Terraform - Benchmark OVH MongoDB Instance with YCSB

The intent of this project is to run the [YCSB (Yahoo! Cloud Serving Benchmark)](https://github.com/brianfrankcooper/YCSB/tree/master) tool on an OVH MongoDB managed instance for the purpose of benchmarking. The script will instantiate the MongoDB OVH instance and a VM where the YCSB script will be executed.

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

    Provide the necessary variables in `terraform.tfvars`. Here is an example:

    ```hcl
    # terraform.tfvars
    variable_name = "value"
    another_variable = "another_value"
    ```

3. **Provide Custom Workload Content:**

    Before running Terraform, make sure to customize the  YCSB workload file `myworkload` according to your requirements. You can see workload examples [here](https://github.com/brianfrankcooper/YCSB/tree/master/workloads)

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

- You can can connect to the VM using the generated ssh private key which you find in file `terraform.tfstate` 
- Logs for the instantiated VM can be found at:
  - `/var/log/ycsb_init.log`
  - `/var/log/ycsb_result.log`

- These log files will be automatically pushed to OVH S3 at the end of the execution.

## Contributing

Feel free to submit issues and enhancement requests.

## License

Distributed under the MIT License. See `LICENSE` for more information.
