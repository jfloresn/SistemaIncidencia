# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161114154043) do

  create_table "cargos", force: :cascade do |t|
    t.string   "nombre"
    t.string   "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "estado_apro_incis", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "estado_incidencia", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "generos", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "historia_incidencia", force: :cascade do |t|
    t.integer  "incidencia_id"
    t.integer  "estado_incidencia"
    t.integer  "estado_apro_inci_id"
    t.datetime "fecha"
    t.string   "observacion"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "incidencia", force: :cascade do |t|
    t.integer  "usuario_id"
    t.integer  "tecnico_id"
    t.datetime "fecha"
    t.integer  "urgencia_id"
    t.string   "asunto"
    t.string   "descripcion"
    t.string   "observacion"
    t.integer  "estado_incidencia_id"
    t.integer  "estado_apro_inci_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "rol_usuarios", force: :cascade do |t|
    t.integer  "rol_id"
    t.integer  "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rols", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "urgencia", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string   "nombre"
    t.string   "ape_paterno"
    t.string   "ape_materno"
    t.integer  "genero_id"
    t.integer  "cargo_id"
    t.string   "usuario_login"
    t.string   "contrasena"
    t.string   "correo"
    t.string   "estado"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
