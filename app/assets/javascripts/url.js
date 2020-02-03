function addToNewUrl(suffix) {
  let path = location.pathname;
  let pattern = /^.*\/new.*$/;

  // URLが正しければ変更は不要
  if (path.match(pattern)) return;

  // URLを変更
  history.replaceState("", "", `${path}/new` + suffix);
}

function addToEditUrl(suffix) {
  let path = location.pathname;
  let pattern = /^.*\/edit.*$/;

  // URLが正しければ変更は不要
  if (path.match(pattern)) return;

  // URLを変更
  history.replaceState("", "", `${path}/edit` + suffix);
}
