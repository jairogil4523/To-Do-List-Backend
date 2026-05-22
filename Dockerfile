FROM ://microsoft.com AS build
WORKDIR /src

# Copiar y restaurar dependencias
COPY *.csproj ./
RUN dotnet restore

# Copiar el resto del código y compilar
COPY . ./
RUN dotnet publish -c Release -o /app/out

# Fase de ejecución usando el entorno de producción de .NET 9
FROM ://microsoft.com AS runtime
WORKDIR /app
COPY --from=build /app/out .

ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "To-Do-List1.dll"]
