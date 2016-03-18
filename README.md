# MCFlickrPullToRefresh

--

###Flickr like pull to refresh animation

![MCFlickrPullToRefresh](https://github.com/msching/MCFlickrPullToRefresh/blob/master/FlickrPullToRefresh/MCFlickrPullToRefresh.gif)

###Original animation

![MCFlickrPullToRefresh](https://github.com/msching/MCFlickrPullToRefresh/blob/master/FlickrPullToRefresh/FlickrPullToRefresh.gif)


###usage

```objc
__weak typeof(self)weakSelf = self;
_headerView = [[FlickrHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)];
_headerView.image = [UIImage imageNamed:@"avatar"];
_headerView.scrollView = self.tableView;
[_headerView setTriggerLoadBlock:^BOOL{
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    [strongSelf startLoading];
    return YES;
}];
[_headerView setLoadFinishBlock:^{
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    [strongSelf finishLoad];
}];
self.tableView.tableHeaderView = _headerView;
```


```
- (void)startLoading
{
    //do your own job, call -setFinishLoad when finished.
}

- (void)finishLoad
{
	//animation finished.
}
```