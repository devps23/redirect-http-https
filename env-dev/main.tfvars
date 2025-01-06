env = "dev"
instance_type = "t2.micro"
vpc_cidr_block="10.10.0.0/16"
subnet_cidr_block="10.10.0.0/16"
default_vpc_id="vpc-02a94ee8944923438"
default_vpc_cidr_block="172.31.0.0/16"
default_route_table_id="rtb-0a2e9ff93585c96fd"
frontend_subnets=["10.10.0.0/19","10.10.32.0/19"]
backend_subnets=["10.10.64.0/19","10.10.96.0/19"]
db_subnets=["10.10.128.0/19","10.10.160.0/19"]
public_subnets=["10.10.192.0/19","10.10.224.0/19"]
zone_id = "Z09583601MY3QCL7AJKBT"
vault_token="hvs.fMGVYmkvteLqprw3itd1iXUe"
bastion_nodes=["172.31.84.158/32"]
availability_zones=["us-east-1a", "us-east-1b"]


