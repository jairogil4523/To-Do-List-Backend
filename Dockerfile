dockerfile
# Fase de compilación usando el SDK de .NET 9 oficial
FROM ://microsoft.com AS build
WORKDIR /src

# Copiar y restaurar dependencias
COPY *.csproj ./
RUN dotnet restore

# Copiar el resto del código y compilar
COPY . ./
RUN dotnet publish -c Release -o /app/out

# Fase de ejecución usando el entorno en producción de .NET 9
FROM ://microsoft.com AS runtime
WORKDIR /app
COPY --from=build /app/out .

# Configurar puerto de escucha estándar
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

# Comando de arranque (Asegúrate de que coincide con el nombre de tu dll)
ENTRYPOINT ["dotnet", "To-Do-List1.dll"]
