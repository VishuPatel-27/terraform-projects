module "ec2-creation" {
    source = "./modules/ec2-creation"
    region_name = var.region_name
    replica_count = var.replica_count
    instance_type = var.instance_type
    image_id = var.image_id
    instance_name = var.instance_name
    sg_name = var.sg_name
}