
create_stair_terminology <- function(path = "man/figures/stair-terminology.png") {

  dir_path <- dirname(path)

if (!dir.exists(dir_path)) {
  dir.create(dir_path, recursive = TRUE)
}
  
png(path,
   width = 800,
  height = 500,
  res = 120
)

par(
  mar = c(1, 1, 1, 1),
  xpd = NA
)

plot(
  NA,
  xlim = c(-2, 9),
  ylim = c(-1.5, 7),
  asp = 1,
  axes = FALSE,
  xlab = "",
  ylab = ""
)

# Example staircase dimensions
n_risers <- 5
rise <- 1
going <- 1.4

# Coordinates
x <- 0:n_risers * going
y <- 0:n_risers * rise


# Draw staircase
for (i in seq_len(n_risers)) {

  # vertical part
  segments(
    x[i], y[i],
    x[i], y[i + 1],
    lwd = 3
  )

  # horizontal part
  segments(
    x[i], y[i + 1],
    x[i + 1], y[i + 1],
    lwd = 3
  )
}


# Finished floors
segments(
  -0.5, 0,
  max(x) + 0.2, 0,
  lty = 2
)

segments(
  -0.5, max(y),
  max(x) + 0.2, max(y),
  lty = 2
)


# Total height
arrows(
  -0.8, 0,
  -0.8, max(y),
  code = 3,
  length = 0.08
)

text(
  -1.25,
  max(y) / 2,
  "total_height",
  srt = 90
)


# Horizontal run
arrows(
  0, -0.5,
  max(x),
  -0.5,
  code = 3,
  length = 0.08
)

text(
  max(x) / 2,
  -0.9,
  "horizontal_run"
)


# Rise dimension (one step)
i <- 3

arrows(
  x[i] - 0.35,
  y[i],
  x[i] - 0.35,
  y[i + 1],
  code = 3,
  length = 0.08
)

text(
  x[i] - 0.7,
  mean(c(y[i], y[i + 1])),
  "rise",
  srt = 90
)


# Going dimension (one step)
arrows(
  x[i],
  y[i + 1] + 0.35,
  x[i + 1],
  y[i + 1] + 0.35,
  code = 3,
  length = 0.08
)

text(
  mean(c(x[i], x[i + 1])),
  y[i + 1] + 0.7,
  "going"
)

  #number of risers
for (i in seq_len(n_risers)) {
  text(
    x[i] + 0.2,
    (y[i] + y[i + 1]) / 2,
    labels = i,
    cex = 0.7
  )
}

  # Number goings
for (i in seq_len(n_risers)) {
  text(
    mean(c(x[i], x[i + 1])),
    y[i + 1] - 0.25,
    labels =  as.roman(i),
    cex = 0.7
    ,  font = 3 
  )
}
  
legend_text <- c(
"Risers: vertical elements (from 1 to 5)
Goings: horizontal elements (from I to IV)"
)

text(
  max(x) - 1,
  min(y) + 1,
  legend_text,
  adj = 0,
  cex = 0.6
)
  
# Upper floor / landing annotation

x_target <- max(x)
y_target <- max(y)

x_text <- x_target 
y_text <- y_target - 1

# segments(x_target, y_target, x_text - 0.05, y_text)

text(
  x_text,
  y_target,
  " Landing step at finished floor level\n (adds an additional going)\n    Or\n Upper finished floor\n (no additional going)",
  adj = -0.1,
  cex = 0.5
)
dev.off()
  
}