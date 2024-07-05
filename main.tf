provider "aws" {
  region = "ap-southeast-1"
}
resource "aws_s3_bucket" "static_website" {
  bucket = "ven-staticwebsite-files" 
}

resource "aws_cloudfront_distribution" "cf_app" {
  origin {
    domain_name = "ven-staticwebsite-files.s3.ap-southeast-1.amazonaws.com"
    origin_id   = "ven-staticwebsite-files"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution"
  default_root_object = "home.html"

  logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  }

  aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    compress         = true
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ven-staticwebsite-files"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 3600
    default_ttl            = 86400
    max_ttl                = 86400
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "/default*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ven-staticwebsite-files"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 3600
    default_ttl            = 86400
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none" 
    }
  }


  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}



