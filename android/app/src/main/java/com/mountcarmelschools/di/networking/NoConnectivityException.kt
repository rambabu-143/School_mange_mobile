package com.mountcarmelschools.di.networking

import java.io.IOException

class NoConnectivityException : IOException() {

    override fun getLocalizedMessage(): String {
        return "NO INTERNET CONNECTIVITY"
    }

}