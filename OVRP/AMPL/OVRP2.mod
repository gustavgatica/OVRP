# Conjuntos
set N := {1..101};  # Incluye clientes y depósito
set ARCOS := {i in N, j in N: i != j};

# Parámetros
param d {N};
param qq default 100;  # Capacidad de cada vehículo
param c {ARCOS};  # Matriz de costos

# Variables
var x{ARCOS} binary;  # 1 si el arco es utilizado, 0 de lo contrario
var u{N} >= 0;  # Variables de eliminación de subtours

# Función Objetivo
minimize CostoTotal:
	sum {(i,j) in ARCOS} c[i,j]*x[i,j];
# Restricciones
s.t.
# Cada cliente es visitado exactamente una vez
rVisitaCliente {j in N: j != 1}:  # Asumiendo que 1 es el depósito
    sum {(i,j) in ARCOS} x[i,j] = 1;

# Cada cliente es salido exactamente una vez, excepto los finales
rSalidaCliente {i in N: i != 1}:
    sum {(i,j) in ARCOS} x[i,j] = 1;

# Eliminación de subtours y restricciones de ruta final
rEliminacionSubtour {(i,j) in ARCOS: i != 1 and j != 1}:
    u[i] - u[j] + qq*x[i,j] <= qq - d[j];

# Restricciones de capacidad
rCapacidad {i in N: i != 1}:
    sum {(i,j) in ARCOS} d[j]*x[i,j] <= qq;

# Los vehículos no regresan al depósito
#rNoRegreso {i in N: i != 1}:
#    x[i, 1] = 0;
