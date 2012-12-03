jQuery ->
  element = $('#js-insights-graph')
  graph = new Rickshaw.Graph.Ajax(
    element: document.getElementById('js-insights-graph')
    width: 500
    height: 250
    renderer: "line"
    interpolation: "linear"
    dataURL: element.data('url')
    series: [
      name: $(element).data('line1')
      color: "#c05020"
    ,
      name: $(element).data('line2')
      color: "#30c020"
    ]
    onComplete: (transport) ->
      hoverDetail = new Rickshaw.Graph.HoverDetail(graph: transport.graph)
      legend = new Rickshaw.Graph.Legend(graph: transport.graph,element: document.getElementById("rickshaw_legend"))
      shelving = new Rickshaw.Graph.Behavior.Series.Toggle(graph: transport.graph,legend: legend)
      axes = new Rickshaw.Graph.Axis.Time(graph: transport.graph)
      axes.render()      
  )
