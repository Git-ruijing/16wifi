/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{

    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    float w;
    float h;
    if (self.tag==1111111) {
        
            w=image.size.width/(image.size.height/200);
        
        if (w>300) {
            w=300;
            
        }
        
        self.frame=CGRectMake(10+(300-w)/2, self.frame.origin.y, w, 200);
    }
    
    if (self.tag==100000) {
        

  
        h=image.size.height*320/image.size.width;
        w=320;
        
        float z;
        if (h>SCREENHEIGHT) {
            z=0;
        }else{
        
            z=(SCREENHEIGHT-h)/2;
        }
        self.frame=CGRectMake(0, z, w,h);
        UIScrollView *sss=(UIScrollView *)self.superview;
        sss.contentSize=CGSizeMake(380, h);
    }
    self.image = image;

}

@end
