var ResultPanel = React.createClass({
  readFromElement: function() {
    var pointHash = {};
    var $peopleList = $('.people-list ul li');
    if ($peopleList.length <= 0) {
      return false;
    }
    $peopleList.each(function(i, ele) {
      var point = $(ele).attr('data-point')
      if (point) {
        var pointCount = pointHash[point] || 0;
        pointHash[point] = (pointCount += 1);
      }
    });

    var maxPointCount = 0;
    $.each(pointHash, function(k, v){
      if (v > maxPointCount) {
        maxPointCount = v;
      }
    });

    keys = Object.keys(pointHash),
    len = keys.length;

    keys.sort(function(a, b) {
      return parseInt(a) - parseInt(b)
    });

    var pointArray = [];
    for (i = (len-1), j=0; i >= 0; i--, j++) {
      point = keys[i];
      count = pointHash[point];
      barWidth = count/maxPointCount * 100;
      pointArray.push({point: point, count: count, barWidth: barWidth, color: barColors[point]})
    }
    this.setState({data: pointArray});
  },
  getInitialState: function() {
    return {data: []};
  },
  componentDidMount: function() {
    EventEmitter.subscribe("showResultPanel", this.readFromElement);
  },
  render: function() {
    var pointBars = this.state.data.map(function(pointBar) {
      return (
        <PointBar key={pointBar.point+ '-' +pointBar.count} point={pointBar.point} count={pointBar.count} barWidth={pointBar.barWidth} color={pointBar.color} />
      );
    });

    var resultChart = (function() {
      if (this.syncResult) {
        return (
          <ul className="list-unstyled">
            {pointBars}
          </ul>
        );
      } else {
        return (<div></div>);
      }
    })();

    return (
      <div className="container-fluid" style={{clear: 'both', width: '100%'}}>
        <div className="row-container container-fluid">
          {resultChart}
        </div>
      </div>
    );
  }
});