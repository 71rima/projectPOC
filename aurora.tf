module "cluster" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-rds-aurora.git?ref=c9e4933177c6d972dca6c45be0178dc2928e42b1" #source with commit hash to prevent supply chain attack risk

  name                       = "aurora-db-mysql"
  engine                     = "aurora-mysql"
  engine_version             = "8.0.mysql_aurora.3.02.0"
  master_username            = "root"
  auto_minor_version_upgrade = true #

  instances = {
    1 = {
      instance_class      = "db.t2.small" #db.r5.large
      publicly_accessible = true
    }
    2 = {
      identifier     = "mysql-static-1"
      instance_class = "db.t2.small" #db.r5.2xlarge
    }
    3 = {
      identifier     = "mysql-excluded-1"
      instance_class = "db.t2.small" #db.r5.xlarge
      promotion_tier = 15
    }
  }

  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group_name
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
    kms_vpc_endpoint = {
      type                     = "egress"
      from_port                = 443
      to_port                  = 443
      source_security_group_id = module.vpc_endpoints.security_group_id #
    }
  }

  apply_immediately                      = true
  skip_final_snapshot                    = true
  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = "aurora"
  db_cluster_parameter_group_family      = "aurora-mysql8.0"
  db_cluster_parameter_group_description = "aurora example cluster parameter group"
  db_cluster_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 120
      apply_method = "immediate"
      }, {
      name         = "innodb_lock_wait_timeout"
      value        = 300
      apply_method = "immediate"
      }, {
      name         = "log_output"
      value        = "FILE"
      apply_method = "immediate"
      }, {
      name         = "max_allowed_packet"
      value        = "67108864"
      apply_method = "immediate"
      }, {
      name         = "aurora_parallel_query"
      value        = "OFF"
      apply_method = "pending-reboot"
      }, {
      name         = "binlog_format"
      value        = "ROW"
      apply_method = "pending-reboot"
      }, {
      name         = "log_bin_trust_function_creators"
      value        = 1
      apply_method = "immediate"
      }, {
      name         = "require_secure_transport"
      value        = "ON"
      apply_method = "immediate"
      }, {
      name         = "tls_version"
      value        = "TLSv1.2"
      apply_method = "pending-reboot"
    }
  ]

  create_db_parameter_group      = true
  db_parameter_group_name        = "aurora"
  db_parameter_group_family      = "aurora-mysql8.0"
  db_parameter_group_description = "aurora example DB parameter group"
  db_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 60
      apply_method = "immediate"
      }, {
      name         = "general_log"
      value        = 0
      apply_method = "immediate"
      }, {
      name         = "innodb_lock_wait_timeout"
      value        = 300
      apply_method = "immediate"
      }, {
      name         = "log_output"
      value        = "FILE"
      apply_method = "pending-reboot"
      }, {
      name         = "long_query_time"
      value        = 5
      apply_method = "immediate"
      }, {
      name         = "max_connections"
      value        = 2000
      apply_method = "immediate"
      }, {
      name         = "slow_query_log"
      value        = 1
      apply_method = "immediate"
      }, {
      name         = "log_bin_trust_function_creators"
      value        = 1
      apply_method = "immediate"
    }
  ]
  backup_retention_period         = 7
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  create_db_cluster_activity_stream     = true
  db_cluster_activity_stream_kms_key_id = module.kms.key_id

  # https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/DBActivityStreams.Overview.html#DBActivityStreams.Overview.sync-mode
  db_cluster_activity_stream_mode = "async"

}

##########supporting resources beside vpc.tf # https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/DBActivityStreams.Prereqs.html#DBActivityStreams.Prereqs.KMS

module "kms" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-kms.git?ref=5508c9cdd6fdb0ed4dcf399f54ba02fb8c31bd4b" 
  # version = "~> 2.0" only applies

  deletion_window_in_days = 7
  description             = "KMS key for Aurora cluster activity stream."
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"

  aliases = ["aurora"]

}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.0"

  vpc_id = module.vpc.vpc_id

  create_security_group      = true
  security_group_name_prefix = "aurora-vpc-endpoints-"
  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.vpc.vpc_cidr_block]
    }
  }

  endpoints = {
    kms = {
      service             = "kms"
      private_dns_enabled = true
      subnet_ids          = module.vpc.database_subnets
    }
  }

}
