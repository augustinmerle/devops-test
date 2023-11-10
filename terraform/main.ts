import { Construct } from "constructs";
import { App, TerraformStack } from "cdktf";
import {  CloudBackend, NamedCloudWorkspace } from "cdktf";
import { AwsProvider } from "@cdktf/provider-aws/lib/provider";
import {S3Bucket} from "@cdktf/provider-aws/lib/s3-bucket"
import { S3BucketObject } from "./.gen/providers/aws/s3-bucket-object";
import { S3BucketAcl } from "./.gen/providers/aws/s3-bucket-acl";
import {MyStackConfig} from "./Constructs/stackConfig"
import * as path from "path";
import {CloudfrontDistribution} from ".gen/providers/aws/cloudfront-distribution";
//import {MyCloudFront} from "./Constructs/modules/cloudfront";
// import {Distribution, OriginAccessIdentity} from "aws-cdk-lib/aws-cloudfront";
// import {S3Origin} from "aws-cdk-lib/aws-cloudfront-origins";


class MyStack extends TerraformStack {
  constructor(scope: Construct, id: string, config: MyStackConfig) {
    super(scope, id);
    const {
      region = "eu-west-3",
      profile= "g8w-dev"
    } = config;
    const s3OriginId = "myS3Origin";
    // define resources here
    new AwsProvider(this, "AWS", {
      region,
      profile

    });
     const bucket = new S3Bucket(this, 'auth', {
       bucket: `bucket1-${config.environment}-auth`,
       //accessControl: BucketAccessControl.PRIVATE,
       tags: {
         environment: `${config.environment}`
       },
     })
    new S3BucketObject(this, "object", {
      bucket: bucket.arn,
      //etag: Token.asString(Fn.filemd5("path/to/file")),
      key: "index.html",
      source: path.resolve(__dirname, '../index.html'),
    });

    new S3BucketAcl(this, "bucket_acl", {
      acl: "private",
      bucket: bucket.id,
    });

    new CloudfrontDistribution(this, "s3_distribution", {
      // aliases: ["mysite.example.com", "yoursite.example.com"],
      comment: "Some comment",
      defaultCacheBehavior: {
        allowedMethods: [
          "DELETE",
          "GET",
          "HEAD",
          "OPTIONS",
          "PATCH",
          "POST",
          "PUT",
        ],
        cachedMethods: ["GET", "HEAD"],
        defaultTtl: 3600,
        forwardedValues: {
          cookies: {
            forward: "none",
          },
          queryString: false,
        },
        maxTtl: 86400,
        minTtl: 0,
        targetOriginId: s3OriginId,
        viewerProtocolPolicy: "allow-all",
      },
      defaultRootObject: "index.html",
      enabled: true,
      isIpv6Enabled: true,
      // loggingConfig: {
      //   bucket: "mylogs.s3.amazonaws.com",
      //   includeCookies: false,
      //   prefix: "myprefix",
      // },
      orderedCacheBehavior: [
        {
          allowedMethods: ["GET", "HEAD", "OPTIONS"],
          cachedMethods: ["GET", "HEAD", "OPTIONS"],
          compress: true,
          defaultTtl: 86400,
          forwardedValues: {
            cookies: {
              forward: "none",
            },
            headers: ["Origin"],
            queryString: false,
          },
          maxTtl: 31536000,
          minTtl: 0,
          pathPattern: "/content/immutable/*",
          targetOriginId: s3OriginId,
          viewerProtocolPolicy: "redirect-to-https",
        },
        {
          allowedMethods: ["GET", "HEAD", "OPTIONS"],
          cachedMethods: ["GET", "HEAD"],
          compress: true,
          defaultTtl: 3600,
          forwardedValues: {
            cookies: {
              forward: "none",
            },
            queryString: false,
          },
          maxTtl: 86400,
          minTtl: 0,
          pathPattern: "/content/*",
          targetOriginId: s3OriginId,
          viewerProtocolPolicy: "redirect-to-https",
        },
      ],
      origin: [
        {
          domainName: bucket.bucketRegionalDomainName,
          //originAccessControlId: defaultVar.id,
          originId: s3OriginId,
        },
      ],
      priceClass: "PriceClass_200",
      restrictions: {
        geoRestriction: {
          locations: ["US", "CA", "GB", "DE"],
          restrictionType: "whitelist",
        },
      },
      tags: {
        environment: config.environment,
      },
      viewerCertificate: {
        cloudfrontDefaultCertificate: true,
      },
    });

  }
}

const app = new App();
new MyStack(app, "stack-dev", { environment: "dev" });
//new MyStack(app, "stack-staging",    { environment: "staging" });
//new MyStack(app, "stack-production", { environment: "prod"    });

new CloudBackend(app, {
  hostname: "app.terraform.io",
  organization: "devops-test-alv",
  workspaces: new NamedCloudWorkspace("devops-test-bk")
});
app.synth();
