export function isAuthenticated() {
    return !!localStorage.getItem('token')   // remplace plus tard par un vrai check (JWT, cookie, etc.)
}
