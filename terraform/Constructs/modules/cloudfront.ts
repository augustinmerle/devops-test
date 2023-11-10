import {CloudfrontDistribution} from "../../.gen/providers/aws/cloudfront-distribution";
import {TerraformStack} from "cdktf";
import { Construct } from "constructs";


export class ModuleCloudFront extends TerraformStack {
    constructor(scope: Construct, id: string) {
        super(scope, id);

//            const provider = new AwsProvider(this, "aws", {
//            region: "us-west-2",
//        });
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

