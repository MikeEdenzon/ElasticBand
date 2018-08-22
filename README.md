# ElasticBand
<img src="https://github.com/medenzon/ElasticBand/blob/master/Diagrams/demo.gif" width="300px" align="right"></img>
ElasticBand is a simple iOS app that demonstrates the use of <a href="https://developer.apple.com/documentation/uikit/uitouch">UITouches</a> and <a href="https://developer.apple.com/documentation/quartzcore">CoreAnimation</a> to simulate elasticity.<br>
<br>
The center point of the bend is (elastic point) is generated based on the user's touch location relative to the initial center point of the band. The (<i>x</i>, <i>y</i>) values of the elastic point are calculated using the following equations:<br>
<br>
&nbsp;&nbsp;<img src="https://github.com/medenzon/ElasticBand/blob/master/Diagrams/x.png" width="200px"></img><br>
&nbsp;&nbsp;<img src="https://github.com/medenzon/ElasticBand/blob/master/Diagrams/y.png" width="200px"></img>
<h2>Build & Run Instructions</h2>
  <ol>
    <li>Open &nbsp; <code>GravityBlocks.xcodeproj</code></li>
    <li>Connect your iOS device</li>
    <li>Click 'Run' &nbsp; (⌘+R)</li>
  </ol>
<br>
<br>
<p>
Elastic Band is written in <a href="https://swift.org">Swift 3.3</a> and can be deployed to a compatible iOS simulator or any iOS device running <a href="https://en.wikipedia.org/wiki/IOS_10">iOS 10.3</a> or later.
</p>
