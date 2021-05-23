output "security_group_id"{
    value=local.security_group_id
}

output "ec2_instance_ids"{
    value=local.instance_ids
}

output "ec2_instance_count"{
    value=length(local.instance_ids)
}