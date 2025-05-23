// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Función para obtener el valor de una cookie por su nombre
function getCookie(name) {
    const cookies = document.cookie.split(';');
    for (let i = 0; i < cookies.length; i++) {
        const cookie = cookies[i].trim();
        if (cookie.startsWith(name + '=')) {
            return cookie.substring(name.length + 1);
        }
    }
    return null;
}

// Transferir token y datos de usuario de cookies a localStorage y sessionStorage
document.addEventListener('DOMContentLoaded', function() {
    // Obtener valores de cookies
    const authToken = getCookie('auth_token');
    const userData = getCookie('user_data');
    
    // Almacenar token en localStorage y sessionStorage
    if (authToken) {
        localStorage.setItem('authToken', authToken);
        sessionStorage.setItem('authToken', authToken);
    }

  // Almacenar datos de usuario en localStorage y sessionStorage
    if (userData) {
        try {
        // Intentar decodificar el valor de la cookie
            const decodedUserData = decodeURIComponent(userData);
            const parsedUserData = JSON.parse(decodedUserData);
            localStorage.setItem('user', JSON.stringify(parsedUserData));
            sessionStorage.setItem('user', JSON.stringify(parsedUserData));
        } catch (e) {
            console.error('Error al decodificar user_data:', e);
        try {
            localStorage.setItem('user', userData);
            sessionStorage.setItem('user', userData);
        } catch (e2) {
            console.error('Error al almacenar user_data:', e2);
        }
        }
    }
});

// Función global para verificar el almacenamiento
window.checkStorage = function() {
    const localToken = localStorage.getItem('authToken');
    const sessionToken = sessionStorage.getItem('authToken');
    const user = localStorage.getItem('user');
    const cookies = document.cookie;
    
    const message = `Estado del almacenamiento:\n\n
    Token en localStorage: ${localToken || 'No encontrado'}\n
    Token en sessionStorage: ${sessionToken || 'No encontrado'}\n
    Usuario en localStorage: ${user || 'No encontrado'}\n\n
    Cookies: ${cookies || 'No hay cookies'}`;
    
    console.log(message);
    alert(message);
};
