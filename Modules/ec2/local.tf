locals{
    instance_ids=aws_instance.web.*.id
    security_group_id=aws_security_group.web_sg.*.id
}