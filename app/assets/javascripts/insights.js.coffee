jQuery ->
  graph = new Rickshaw.Graph.Ajax(
    element: document.getElementById('js-insights-graph')
    width: 500
    height: 250
    renderer: "line"
    interpolation: "linear"
    dataURL: $('#js-insights-graph').data('url')
    onData: (d) ->
      d[0].data[0].y = 80
      d

    series: [
      name: "retweet"
      color: "#c05020"
    ,
      name: "replies"
      color: "#30c020"
    ]
    onComplete: (transport) ->
      hoverDetail = new Rickshaw.Graph.HoverDetail(graph: transport.graph)
      legend = new Rickshaw.Graph.Legend(graph: transport.graph,element: document.getElementById("rickshaw_legend"))
      shelving = new Rickshaw.Graph.Behavior.Series.Toggle(graph: transport.graph,legend: legend)
      axes = new Rickshaw.Graph.Axis.Time(graph: transport.graph)
      axes.render()      
  )
