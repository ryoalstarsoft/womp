async function getQuizData(){

	const quizViewer = document.getElementById('quiz-container');
	const id = quizViewer.getAttribute('data-quote-id');

	try {
		const respQuiz = await fetch('/viewer-from-quote?quote_id=' + id)
		const viewerData = await respQuiz.json();

		return viewerData;
	} catch(e){
		throw new Error(e);
	}
}

async function initializePricingQuiz(){
	const viewers = $('#quiz-container');

	if(!viewers || !viewers.length)
		return;

	const data = await getQuizData();

	var camera, controls, scene, renderer, viewer;
	var geom, mat;
	viewer = document.getElementById('quiz-container');

	scene = new THREE.Scene();

	renderViewer = function(){
		renderer.render(scene, camera);
	}

	// configure viewer container
	var width = viewer.offsetWidth / 2
	viewer.style.height = width + "px"; // set height as width
	renderer = new THREE.WebGLRenderer({ antialias: true });
	renderer.setPixelRatio(window.devicePixelRatio);
	renderer.setSize(viewer.offsetWidth, viewer.offsetHeight);
	viewer.appendChild(renderer.domElement);

	// configure camera
	camera = new THREE.PerspectiveCamera(40, viewer.offsetWidth / viewer.offsetHeight, 1, 1000);
	camera.position.z = 150;

	// configure lights
	var light = new THREE.DirectionalLight(0xffffff);
	light.position.set(5, 5, 10);
	scene.add(light);
	var light = new THREE.DirectionalLight(0xffffff);
	light.position.set(-10, -10, 0);
	scene.add(light);
	var light = new THREE.AmbientLight(0x545159);
	scene.add(light);

	// configure controls
	controls = new THREE.OrbitControls(camera, renderer.domElement);
	controls.addEventListener('change', renderViewer);
	controls.enablePan = false;

	//measure mesh in m so the meshes aren't ridiculously big
	var x = data.object_width,
	z = data.object_height,
	y = data.object_depth;

	switch(data.object_most_like){
		case('cube'):
			geom = new THREE.BoxGeometry(x, y, z);
			break;
		case('sphere'):
			geom = new THREE.SphereGeometry(x/2, 32, 32);
			break;
		case('cone'):
			geom = new THREE.ConeGeometry(x/2, y, 32);
			break;
	}

	mat = new THREE.MeshLambertMaterial({ color: 0x958D7B });

	var mesh = new THREE.Mesh(geom, mat);
	scene.add(mesh);

	// configure scene background
	scene.background = new THREE.Color( 0xd3d3d3 );;

	// Re-Position Camera
	geom.computeBoundingBox();

	console.log('geom', geom.boundingBox.getSize());

	var center = geom.boundingBox.getCenter();
	var size = geom.boundingBox.getSize();
	var maxDim = Math.max(size.x, size.y, size.z);
	var fov = camera.fov * (Math.PI / 180);
	var cameraZ = Math.abs(maxDim / 4 * Math.tan(fov * 2)) * 1.5;
	camera.position.set(center.x, center.y, cameraZ);

	// Set far edge
	var minZ = geom.boundingBox.min.z;
	var cameraToFarEdge = ( minZ < 0 ) ? -minZ + cameraZ : cameraZ - minZ;
	camera.far = cameraToFarEdge * 3;
	camera.updateProjectionMatrix();

	// set camera to rotate around center of loaded object
	controls.target = center;

	// prevent camera from zooming out far enough to create far plane cutoff
	controls.maxDistance = cameraToFarEdge * 2;

	renderViewer();

	// handle resize
	window.addEventListener('resize', onWindowResize, false);

	function onWindowResize() {
		var width = viewer.offsetWidth / 2
		viewer.style.height = width + "px"; // set height as width

		camera.aspect = viewer.offsetWidth / viewer.offsetHeight;
		camera.updateProjectionMatrix();
		renderer.setSize(viewer.offsetWidth, viewer.offsetHeight);
	}

}
