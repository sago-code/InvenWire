import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["email", "password"]

    connect() {
        console.log("Login controller connected")
    }

    submitForm(event) {
    }

    checkStoredToken() {
        const localToken = localStorage.getItem('authToken');
        const sessionToken = sessionStorage.getItem('authToken');
        const user = JSON.parse(localStorage.getItem('user') || '{}');
        
        alert(`
        Token en localStorage: ${localToken ? 'Presente' : 'No encontrado'}
        Token en sessionStorage: ${sessionToken ? 'Presente' : 'No encontrado'}
        Usuario almacenado: ${user.name || 'No encontrado'}
        `);
    }
}