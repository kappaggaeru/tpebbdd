<nav class="navbar navbar-expand-lg navbar navbar-dark bg-primary">
  <a class="navbar-brand" href="home">
		<img src="https://getbootstrap.com/docs/4.5/assets/brand/bootstrap-solid.svg" width="30" height="30" class="d-inline-block align-top" alt="" loading="lazy">
		PJL Sistemas Tandil
	</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
    <div class="navbar-nav">
      <a class="nav-item nav-link" href="home">Inicio</a>
      <a class="nav-item nav-link" href="usuarios">Usuarios</a>
      <a class="nav-item nav-link" href="cargar">Cargar Categorias <span class="sr-only">(current)</span></a>
        {if {$logeado}}  
            <a class="nav-item nav-link" href="logout">Cerrar sesión</a>
        {/if}
    </div>
  </div>
</nav>